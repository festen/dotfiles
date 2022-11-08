import { registerTask, ShellPipeSink } from 'fstask'
import { homebrew } from './homebrew.task'
import { linkDotfiles } from './link-dotfiles.task'
import { $, fs, nothrow, os, path } from 'zx'

export const homebrewBundle = 'Install Dependencies'
const brewfile =
  process.env.HOMEBREW_BUNDLE_FILE ??
  path.join(os.homedir(), '.homebrew', 'Brewfile')

registerTask({
  name: homebrewBundle,
  uses: [homebrew, linkDotfiles],
  run: async ({ setStatus, setOutput, setWarning, setTitle }) => {
    if (brewfile === undefined || !(await fs.pathExists(brewfile))) {
      throw new Error(
        `Could not find Brewfile at location ${brewfile ?? 'undefined'}`,
      )
    }

    // make sure that we are using the latest version of homebrew
    setTitle(`${homebrewBundle} - update homebrew`)
    await $`brew update`
    setTitle(homebrewBundle)

    // disable analytics
    await $`brew analytics off`

    if ((await $`brew bundle check --file ${brewfile}`.exitCode) === 0) {
      setStatus('Skipped')
      return
    }

    const res = await nothrow(
      $`brew bundle install --cleanup --file ${brewfile}`,
    ).pipe(new ShellPipeSink(setOutput))
    if (res.exitCode !== 0) {
      setWarning('bundle executed with errors')
    }
  },
})
