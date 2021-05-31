const path = require('path')
const exec = require('child_process').execFileSync

module.exports = () => {
  const script = path.resolve(path.join(__dirname, '../scripts', 'setup.sh'))
  exec(script, { stdio: 'inherit', shell: true, killSignal: 'SIGKILL' })
}
