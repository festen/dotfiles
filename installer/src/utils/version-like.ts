import { ProcessOutput } from 'zx'

type MaybePromise<T> = T | Promise<T>
export type VersionLike =
  | MaybePromise<string>
  | MaybePromise<ProcessOutput>
  | MaybePromise<{ version: string }>
