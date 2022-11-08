import { registerStep } from 'fstask'

export const preparation = -1
export const main = 0
export const cleanup = 1

registerStep(preparation, 'Preparation')
registerStep(main, 'Main')
registerStep(cleanup, 'Cleanup')
