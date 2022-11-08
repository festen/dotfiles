import { registerInstallTask } from '../utils'
import { $ } from 'zx'

export const homebrew = 'Homebrew'

registerInstallTask({
  name: homebrew,
  sudo: '/bin/bash -c',
  versionCommand: () => $`brew -v`,
  installCommand: () =>
    $`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null`,
  rollbackCommand: () =>
    $`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uminstall.sh)" </dev/null`,
})
