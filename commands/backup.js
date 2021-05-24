const chalk = require('chalk')
const ora = require('ora')
const path = require('path')
const S3 = require('s3-sync-client')

// Load .env config file
require('dotenv').config()

// Local Directories
const localAudioFiles = path.resolve(path.join(__dirname, '../mimic-recording-studio', 'backend', 'audio_files'))
const localDatabase = path.resolve(path.join(__dirname, '../mimic-recording-studio', 'backend', 'db'))

// S3 Bucket Directors
const s3AudioFiles = `${process.env.AWS_S3_BUCKET}/audio_files`
const s3Database = `${process.env.AWS_S3_BUCKET}/db`

module.exports = async options => {
  // Create Progress Indicator
  const text = chalk.bold(`Performing Backup${options.dryRun ? ' ( Dry Run Only )' : ''}`).concat(chalk.dim(' [Ctrl-C to Cancel]'))
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
    spinner.text = chalk.bold(`Performing Backup${options.dryRun ? ' ( Dry Run Only )' : ''}:`).concat(chalk.dim(' ‣ Audio Files  [Ctrl-C to Cancel]'))

    // Upload Local Audio Files to AWS S3
    await sync.bucketWithLocal(localAudioFiles, s3AudioFiles, { del: options.delete, dryRun: options.dryRun }).catch(err => console.log(err))

    // Output Progress
    spinner.text = chalk.bold(`Performing Backup${options.dryRun ? ' ( Dry Run Only )' : ''}:`).concat(chalk.dim(' ‣ Database  [Ctrl-C to Cancel]'))

    // Upload Local SQLite Database to AWS S3
    await sync.bucketWithLocal(localDatabase, s3Database, { del: options.delete, dryRun: options.dryRun }).catch(err => console.log(err))

    // Output Progress
    spinner.succeed('Backup Complete')
  } catch (err) {
    spinner.fail(`AWS S3 ERROR: ${err.message} - Check your .env file`)
    process.exit(1)
  }
}
