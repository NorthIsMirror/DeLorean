@delorean.exec.command.future.util.schematic () {
  @delorean.import './stderr/*'

  builtin local 'in' 'out' 'su' 'cmd' 'schema' 'mtime'

  in="${1}"
  out="${2}"
  su="${3}"

  @delorean.log-info "${0} () => Materialize ${in} to ${out} ${su:+'with sudo.'}"

  cmd="${0}.stdout--${in}"
  @delorean.import "./stdout/${in}"

  if ! (( ${+functions[${cmd}]} )); then
    ${0}.stderr.missing "${cmd}"
    builtin return 1
  fi

  if [[ -s "${out}" ]]; then
    ${0}.stderr.conflict "${out}"
    builtin return 1
  fi

  #
  # Read in and replace any strings with absolute location.
  #

  schema="$("${cmd}")"
  schema="${${schema}//__LOCATION__/${DELOREAN[loc]}}"
  schema="${${schema}//__ZDOTDIR__/${DELOREAN[zdotdir]}}"

  #
  # Write out.
  #

  builtin print "${schema}" | ${su:+'sudo'} builtin command tee "${out}" >/dev/null

  #
  # Get mtime.
  #

  mtime="$(builtin zmodload -F 'zsh/stat' 'b:zstat'; builtin zstat '+mtime' "${out}")"

  if ! [[ "${mtime}" ]]; then
    ${0}.stderr.mtime "${out}"
    builtin return 1
  fi

  #
  # Set epoch attr to mtime.
  #

  ${su:+'sudo'} builtin command zsh -c "builtin zmodload 'zsh/attr'; builtin zsetattr ${out} 'epoch' ${mtime}" &>/dev/null

  if (( ${?} )); then
    ${0}.stderr.epoch "${out}"
    builtin return 1
  fi

  builtin return 0
}