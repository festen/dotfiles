import { registerTask, ShellPipeSink } from 'fstask'
import { git } from './git.task'
import { fs, $, sleep, cd, path, os } from 'zx'

export const dotfiles = 'Dotfiles'
export const dotdir = process.env.DOTDIR ?? path.join(os.homedir(), '.dotfiles')
export const assetsdir = path.join(dotdir, 'assets')
const upstream = 'git@github.com:festen/dotfiles.git'

const hasChanges = (dir: string): Promise<boolean> => {
  return $`git -C ${dir} status --porcelain`.then((r) => r.stdout.length > 0)
}

registerTask({
  name: dotfiles,
  uses: [git],
  run: async ({ setWarning, setOutput, setStatus }) => {
    const sink = new ShellPipeSink(setOutput)
    if (!(await fs.pathExists(dotdir))) {
      setOutput('Cloning dotfiles from source')
      await $`git clone ${upstream} ${dotdir}`.pipe(sink)
      setStatus(dotdir)
    } else if (!(await hasChanges(dotdir))) {
      setOutput('Updating dotfiles from source')
      cd(dotdir)
      await $`git pull`.pipe(sink)
      setStatus(dotdir)
    } else {
      setWarning('Dotfile directory has changes, keeping as-is')
      await sleep(1000)
      setStatus('Changes detected')
    }
  },
})
