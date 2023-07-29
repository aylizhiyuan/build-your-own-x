import { fib } from 'fib.so'
import { setTimeout } from 'uv.so'

console.log(`fib(10) = ${fib(10)}`)
// 遇到这种异步的代码,则使用timer.c里面的代码来进行执行
setTimeout(() => console.log('B'), 0)
Promise.resolve().then(() => console.log('A'))

setTimeout(() => {
  setTimeout(() => console.log('D'), 0)
  Promise.resolve().then(() => console.log('C'))
}, 1000)
