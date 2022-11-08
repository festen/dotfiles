import { registerTask } from 'fstask'
import { extractVersion, verify } from '../utils'
import { commandLineTools } from './command-line.tools.task'
import { $ } from 'zx'

export const git = 'Git'

registerTask({
  name: git,
  uses: [commandLineTools],
  run: async ({ setOutput, setStatus }) => {
    const rawVersion = (await $`git --version`).stdout
    const version =
      (await extractVersion(rawVersion.replaceAll('\n', ''))) ?? ''
    if (!(await verify(() => version, setOutput))) {
      throw new Error('Could not find git')
    }
    setStatus(version)
  },
})
