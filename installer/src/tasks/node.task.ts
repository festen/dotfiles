import { ShellPipeSink } from 'fstask'
import { nvm } from './nvm.task'
import { $nvm, registerInstallTask } from '../utils'

export const node = 'Node'

registerInstallTask({
  name: node,
  uses: [nvm],
  versionCommand: () => $nvm`node -v`,
  installCommand: async ({ setOutput }) => {
    const sink = new ShellPipeSink(setOutput)
    await $nvm`nvm install 16`.pipe(sink)
    await $nvm`nvm alias default 16`.pipe(sink)
  },
})
