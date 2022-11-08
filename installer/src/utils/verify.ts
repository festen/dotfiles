import { extractVersion } from './extract-version'
import { VersionLike } from './version-like'

const isVersionObject = (input: VersionLike): input is { version: string } =>
  Object.getOwnPropertyDescriptor(input, 'version') !== undefined

export async function verify(
  versionFn: () => VersionLike,
  out: (text: string) => void,
): Promise<boolean> {
  const result = await versionFn()
  const version = isVersionObject(result)
    ? result.version
    : (await extractVersion(result)) ?? ''
  out(version)
  return version.length > 0
}
