import { wrapCommand } from 'fstask'
import { os, path, ProcessOutput, ProcessPromise } from 'zx'

export const $nvm: (
  pieces: TemplateStringsArray,
  ...args: any
) => ProcessPromise<ProcessOutput> = wrapCommand(
  `. ${path.join(os.homedir(), '.nvm', 'nvm.sh')};`,
)
