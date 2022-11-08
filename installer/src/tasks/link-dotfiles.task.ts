import { fs, $, sleep, cd, path, os, glob } from 'zx'
import { registerTask } from 'fstask'
import { assetsdir, dotfiles } from './dotfiles.task'

export const linkDotfiles = 'Link Dotfiles'

const relativeAssetsDir = path.relative(os.homedir(), assetsdir)

registerTask({
  name: linkDotfiles,
  uses: [dotfiles],
  run: async () => {
    cd(os.homedir())
    const features = await glob(relativeAssetsDir, {
      onlyDirectories: true,
      deep: 1,
      cwd: os.homedir(),
    })
    const files = await Promise.all(
      features.map((feature) => fs.readdir(feature)),
    )
    const paths = features.flatMap((feature, index) =>
      files[index].map((file) => ({
        original: path.join(feature, file),
        link: file,
      })),
    )
    await Promise.all(paths.map(({ link }) => fs.remove(link)))
    await Promise.all(
      paths.map(({ original, link }) => fs.ensureSymlink(original, link)),
    )
  },
  rollback: async ({ setStatus, setWarning }) => {
    cd(os.homedir())
    const filesToRemove = []

    const findOutput = await $`find ${os.homedir()} -maxdepth 1 -type l`
    const files = findOutput.stdout.trim().split('\n')

    for (const file of files) {
      const linkPath = (await $`readlink ${file}`).stdout.trim()
      if (linkPath.startsWith(relativeAssetsDir)) {
        filesToRemove.push(file)
      }
    }

    if (filesToRemove.length === 0) {
      const msg = 'Nothing to remove'
      setWarning(msg)
      await sleep(1000)
      setStatus(msg)
    } else {
      await Promise.all(filesToRemove.map((file) => fs.remove(file)))
    }
  },
})
