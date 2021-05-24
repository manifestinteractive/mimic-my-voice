const path = require('path')
const shell = require('shelljs')

module.exports = () => {
  const script = path.resolve(path.join(__dirname, '../scripts', 'train.sh'))
  shell.exec(script)
}
