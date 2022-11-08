import { registerTask, ShellPipeSink } from 'fstask'
import { node } from './node.task'
import { nothrow } from 'zx'
import { $nvm, extractVersion } from '../utils'

export const getVersion = async (): Promise<string> => {
  return (await extractVersion(nothrow($nvm`npm -v`))) ?? ''
}

export const npm = 'Npm'

registerTask({
  name: npm,
  uses: [node],
  run: async ({ setOutput, setStatus, setTitle }) => {
    setTitle('Updating Npm')
    await $nvm`npm install -g npm`.pipe(new ShellPipeSink(setOutput))
    const version = await getVersion()
    setTitle(npm)
    setStatus(version)
  },
})
