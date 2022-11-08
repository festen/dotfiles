import { registerTask, ShellPipeSink } from 'fstask'
import { dotdir, dotfiles } from './dotfiles.task'
import { $, path } from 'zx'

export const tweaks = 'Tweaks'
const script = path.join(dotdir, 'assets', 'macos.sh')

registerTask({
  name: tweaks,
  sudo: '/bin/bash -c',
  uses: [dotfiles],
  run: ({ setOutput }) => $`source ${script}`.pipe(new ShellPipeSink(setOutput)),
})
