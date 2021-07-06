const path = require('path')
const exec = require('child_process').execFileSync

module.exports = () => {
  const script = path.resolve(path.join(__dirname, '../scripts', 'config.sh'))
  exec(script, { stdio: 'inherit', shell: true, killSignal: 'SIGKILL' })
}
