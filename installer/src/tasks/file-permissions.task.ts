import { registerTask } from 'fstask'
import { cd, fs, glob, os } from 'zx'
import { iCloud } from './icloud.task'
import { linkDotfiles } from './link-dotfiles.task'

export const filePermissions = 'File permissions'

const setPermission = async (pattern: string, mode: string): Promise<void> => {
  const files = await glob(pattern)
  await Promise.all(files.map((file) => fs.chmod(file, mode)))
}

registerTask({
  name: filePermissions,
  uses: [iCloud, linkDotfiles],
  run: async () => {
    cd(os.homedir())
    await Promise.all([
      setPermission('.shh', '0700'),
      setPermission('.ssh/**/*', '400'),
    ])
    await Promise.all([
      setPermission('bin/**/*', '755'),
      setPermission('.private', '600'),
      setPermission('.ssh/{config,known_hosts}', '644'),
      setPermission('.ssh/{*.pub,authorized_keys,*public*,*.token}', '444'),
    ])
  },
})
