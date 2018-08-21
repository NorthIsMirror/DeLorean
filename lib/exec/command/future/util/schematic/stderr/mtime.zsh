@delorean.exec.command.future.util.schematic.stderr.mtime () {
  @delorean.import '~/util/stderr/padding'
  @delorean.util.stderr.padding

  builtin local 'out'
  out="${1}"

<<EOF >&2

${DELOREAN_TRUNK[T]}Failed to get mtime of materialized schematic:
${DELOREAN_TRUNK[I]}
${DELOREAN_TRUNK[L]}${out}

EOF
}
