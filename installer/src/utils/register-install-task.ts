import { ExecuteFunctionArguments, registerTask } from 'fstask'
import { verify } from './verify'
import { VersionLike } from './version-like'
import { RegisterTaskOptions } from 'fstask/dist/core'

type RegisterInstallTaskOptions = Omit<
RegisterTaskOptions<void>,
'run' | 'rollback'
> & {
  versionCommand: (args: ExecuteFunctionArguments<any>) => VersionLike
  installCommand: (args: ExecuteFunctionArguments<any>) => any
  rollbackCommand?: (args: ExecuteFunctionArguments<any>) => any
}

export const registerInstallTask = (
  registerArgs: RegisterInstallTaskOptions,
): void => {
  registerTask({
    ...registerArgs,
    run: async (runArgs) => {
      const {
        name,
        versionCommand,
        installCommand,
        setStatus,
        setOutput,
        setTitle,
      } = { ...registerArgs, ...runArgs }

      // verify before install
      if (await verify(() => versionCommand(runArgs), setStatus)) {
        return
      }

      // install
      setOutput(`Could not find ${name}`)
      setTitle(`Installing ${name}`)
      await installCommand(runArgs)

      // verify after install
      if (await verify(() => versionCommand(runArgs), setStatus)) {
        return
      }

      // Error out
      throw new Error(`Could not install ${name}`)
    },
    rollback: async (runArgs) => {
      const {
        name,
        versionCommand,
        rollbackCommand,
        setStatus,
        setWarning,
        setTitle,
      } = { ...registerArgs, ...runArgs }

      setTitle(`Remove ${name}`)

      // verify
      if (rollbackCommand === undefined) {
        setStatus('Skipped')
        setWarning(`No rollback script detected for ${name}`)
        return
      }

      if (!(await verify(() => versionCommand(runArgs), setStatus))) {
        setStatus('Skipped')
        return
      }

      // rollback
      await rollbackCommand(runArgs)

      // verify after install
      if (await verify(() => versionCommand(runArgs), setStatus)) {
        // Error out
        throw new Error(`Could not remove ${name}`)
      }
    },
  })
}
