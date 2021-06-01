const chalk = require('chalk')
const ora = require('ora')
const path = require('path')
const S3 = require('s3-sync-client')

// Load .env config file
require('dotenv').config({
  path: path.resolve(path.join(__dirname, '../.env'))
})

// Local Directories
const localPath = path.resolve(path.join(__dirname, '../mimic-recording-studio', 'backend'))

// S3 Bucket Directors
const s3AudioFiles = `${process.env.AWS_S3_BUCKET}/audio_files`
const s3Database = `${process.env.AWS_S3_BUCKET}/db`

module.exports = async options => {
  // Create Progress Indicator
  const text = chalk.bold(`Restoring From Backup${options.dryRun ? ' ( Dry Run Only )' : ''}`).concat(chalk.dim(' [Ctrl-C to Cancel]'))
  const spinner = ora(text)

  // Start Indicator
  spinner.start()

  // Create Connection to AWS S3
  try {
    const sync = new S3({
      region: process.env.AWS_S3_REGION,
      credentials: {
          accessKeyId: process.env.AWS_ACCESS_KEY,
          secretAccessKey: process.env.AWS_SECRET_KEY
      }
    })

    // Output Progress
    spinner.text = chalk.bold(`Restoring From Backup${options.dryRun ? ' ( Dry Run Only )' : ''}:`).concat(chalk.dim(' ‣ Audio Files  [Ctrl-C to Cancel]'))

    // Download Remote Audio Files from AWS S3
    await sync.localWithBucket(s3AudioFiles, localPath, { del: false, dryRun: options.dryRun }).catch(err => console.log(err))

    // Output Progress
    spinner.text = chalk.bold(`Restoring From Backup${options.dryRun ? ' ( Dry Run Only )' : ''}:`).concat(chalk.dim(' ‣ Database  [Ctrl-C to Cancel]'))

    // Download Remote SQLite Database from AWS S3
    await sync.localWithBucket(s3Database, localPath, { del: false, dryRun: options.dryRun }).catch(err => console.log(err))

    // Output Progress
    spinner.succeed('Restoring From Backup Complete')
  } catch (err) {
    spinner.fail(`AWS S3 ERROR: ${err.message} - Check your .env file`)
    process.exit(1)
  }
}
