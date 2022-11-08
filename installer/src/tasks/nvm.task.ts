import { $ } from 'zx'
import { $nvm, registerInstallTask } from '../utils'
import { homebrew } from './homebrew.task'

export const nvm = 'Nvm'

registerInstallTask({
  name: nvm,
  uses: [homebrew],
  versionCommand: () => $nvm`nvm -v`,
  installCommand: () =>
    $`curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash </dev/null`,
})
