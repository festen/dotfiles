import { runRegisteredTasks } from 'fstask'
import { $, argv, fs, path, glob } from 'zx'

const getMode = (): 'run' | 'rollback' => {
  if (argv._.length !== 1) throw new Error()
  if ('install'.startsWith(argv._[0])) return 'run'
  if ('uninstall'.startsWith(argv._[0])) return 'rollback'
  throw new Error()
}

const isDebug = Boolean(argv.debug) || Boolean(argv.d)
const isShowHelp = Boolean(argv.h) || Boolean(argv.help)
const isShowVersion = Boolean(argv.v) || Boolean(argv.version)
const assumeYes =
  !process.stdin.isTTY ||
  Boolean(argv.assumeYes) ||
  Boolean(argv['assume-yes']) ||
  Boolean(argv.y)

const showHelp = (): void => {
  process.stdout.write(`
    Usage: ${process.argv0} <install|uninstall> [options]
          -d | --debug      Use debug/verbose mode
          -h | --help       Show this information
          -y | --assume-yes Assumes yes/enter
          -v | --version    Show version
  `)
  process.exit(0)
}

const showVersion = async (): Promise<void> => {
  const packagejson = await fs.readJSON(
    path.join(__dirname, '..', 'package.json'),
  )
  console.log(packagejson.version)
  process.exit(0)
}

export async function main(): Promise<void> {
  try {
    if (isShowHelp) showHelp()
    if (isShowVersion) await showVersion()
    getMode()
  } catch {
    showHelp()
  }

  const files = await glob(path.join(__dirname, '**', '*.task.ts'))
  await Promise.all(files.map(async (file) => await import(file)))
  $.verbose = isDebug
  $.shell = '/bin/zsh'
  await runRegisteredTasks({
    debug: isDebug,
    interactive: !assumeYes,
    mode: getMode(),
  })
}
