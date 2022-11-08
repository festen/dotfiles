import { $, fs, nothrow, ProcessOutput, sleep } from 'zx'
import { extractVersion, registerInstallTask } from '../utils'
import { ShellPipeSink } from 'fstask'

const extractVersions = (softwareUpdateOutput: ProcessOutput): string[] =>
  Array.from(
    softwareUpdateOutput.stdout.matchAll(/Label: (Command Line Tools.*)/g),
  ).map((r) => r[1])

const extractLatest = (list: string[]): string | undefined =>
  list.sort().reverse()?.[0]

const cltDir = '/Library/Developer/CommandLineTools'

export const commandLineTools = 'Command Line Tools'

const showProgress = async (
  out: (txt: string) => void,
  titleOut: (txt: string) => void,
  cancel?: Promise<void>,
): Promise<void> => {
  const estimatedInstallTimeInMs = 500_000
  const steps = 50
  let stop = false
  cancel?.then(() => {
    stop = true
  })
  for (let i = 0; i < steps; i++) {
    if (stop) break
    out(`[${'#'.repeat(i)}${' '.repeat(steps - i)}]`)
    const msRemaining = (estimatedInstallTimeInMs * (steps - i)) / steps
    const minRemaining = msRemaining / 60 / 1000
    const remaining =
      minRemaining < 1 ? '< 1' : Math.floor(minRemaining * 10) / 10
    titleOut(`Installing Command Line Tools ~ ${remaining} minutes remaining`)
    await sleep(Math.floor(estimatedInstallTimeInMs / steps))
  }
  out('')
}

registerInstallTask({
  name: commandLineTools,
  sudo: true,
  versionCommand: async () => {
    if (!(await fs.pathExists(cltDir))) return { version: '' }
    const xcodeSelectV = nothrow($`xcode-select -v`)
    const version = (await extractVersion(xcodeSelectV, /(\d+)/)) ?? ''
    return { version }
  },
  installCommand: async ({ setOutput, setTitle }): Promise<void> => {
    setOutput('Looking for Command Line Tools online')
    const versions = extractVersions(await $`/usr/sbin/softwareupdate -l`)
    const latest = extractLatest(versions)
    if (latest === undefined)
      throw new Error('Could not find Command Line Tools to install')
    setOutput(`Found ${latest}`)

    const sink = new ShellPipeSink(setOutput)
    const placeholder =
      '/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress'
    try {
      await $`/usr/bin/touch ${placeholder}`.pipe(sink)
      setTitle('Installing Command Line Tools')
      let stopProgress: () => void = () => {}
      const cancel = new Promise<void>((resolve) => {
        stopProgress = resolve
      })
      void showProgress(setOutput, setTitle, cancel)
      await $`sudo /usr/sbin/softwareupdate -i ${latest} </dev/null`
      stopProgress()
      await $`sudo /usr/bin/xcode-select --switch ${cltDir}`.pipe(sink)
      setTitle('Install Command Line Tools')
    } finally {
      await $`/bin/rm -fv ${placeholder}`.pipe(sink)
    }
  },
  rollbackCommand: async ({ setOutput }) =>
    await $`sudo rm -rfv ${cltDir}`.pipe(new ShellPipeSink(setOutput)),
})
