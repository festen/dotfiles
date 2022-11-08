import { ProcessOutput } from 'zx'

export async function extractVersion (input: string | Promise<string> | ProcessOutput | Promise<ProcessOutput>, matcher: RegExp = /(\d+\.\d+\.\d+)/g): Promise<string | undefined> {
  const awaitedInput = await input
  const stringInput = awaitedInput instanceof ProcessOutput ? awaitedInput.stdout : awaitedInput
  return matcher.exec(stringInput)?.[1]
}
