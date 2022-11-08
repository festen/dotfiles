import { $, cd, fs, os, path } from 'zx'
import { registerTask } from 'fstask'

export const iCloud = 'iCloud'
const iCloudSource = path.join(
  '.',
  'Library',
  'Mobile Documents',
  'com~apple~CloudDocs',
)
const iCloudHome = path.join('.', 'icloud')
const privateContainer = 'private-settings'

registerTask({
  name: iCloud,
  run: async ({ setOutput, setStatus }) => {
    cd(os.homedir())

    setOutput('Download container')
    await $`brctl download ${path.join(iCloudSource, privateContainer)}`

    setOutput('Link iCloud to home dir')
    await fs.ensureSymlink(path.join(os.homedir(), iCloudSource), iCloudHome)

    setOutput('Link container contents')
    const privateFolderNames = await fs.readdir(
      path.join(iCloudHome, privateContainer),
    )

    for (const privateFolderName of privateFolderNames) {
      const dotPrivateFolderName = `.${privateFolderName}`
      setOutput(`Link ${dotPrivateFolderName}`)
      const source = path.join(iCloudHome, privateContainer, privateFolderName)
      const target = dotPrivateFolderName
      await fs.remove(target)
      await fs.ensureSymlink(source, target)
    }
  },
  rollback: async () => {
    cd(os.homedir())
    const filesToRemove = [iCloudHome]

    const findOutput = await $`find ${os.homedir()} -maxdepth 1 -type l`
    const files = findOutput.stdout.trim().split('\n')

    for (const file of files) {
      const linkPath = (await $`readlink ${file}`).stdout.trim()
      if (linkPath.startsWith(iCloudHome)) {
        filesToRemove.push(file)
      }
    }

    await Promise.all(filesToRemove.map((f) => fs.remove(f)))
  },
})
