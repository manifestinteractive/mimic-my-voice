const path = require('path')
const shell = require('shelljs')

module.exports = () => {
  const script = path.resolve(path.join(__dirname, '../scripts', 'studio.sh'))
  shell.exec(script)
}
