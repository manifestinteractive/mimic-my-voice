#!/usr/bin/env node

const debug = require('debug')('cli')
const path = require('path')
const yargs = require('yargs')
const chalk = require('chalk')

const argv = yargs
  .usage('Usage: mimic <command> --switches')
  .command('setup', 'Install Mimic & Recording Studio')
  .command('studio', 'Launch Mimic Recording Studio')
  .command('train', 'Launch Mimic Training')
  .command('backup', 'Backup Mimic Sessions to AWS S3', {
    delete: {
      describe: 'Delete Backup Files not in Local',
      type: 'boolean',
      default: true
    },
    dryRun: {
      describe: 'Backup using Dry Run Only',
      type: 'boolean',
      default: false
    }
  })
  .command('restore', 'Restore Mimic Sessions from AWS S3', {
    delete: {
      describe: 'Delete Local Files not in Backup',
      type: 'boolean',
      default: true
    },
    dryRun: {
      describe: 'Restore using Dry Run Only',
      type: 'boolean',
      default: false
    }
  })
  .example('mimic setup', 'Install Mimic & Mimic Studio')
  .example('mimic studio', 'Launch Mimic Studio')
  .example('mimic train', 'Launch Mimic Training')
  .example('mimic backup', 'Backup Mimic Sessions to AWS S3')
  .example('mimic backup --dry-run', 'Test Backup via Dry Run')
  .example('mimic restore', 'Restore Mimic Sessions from AWS S3')
  .example('mimic restore --dry-run', 'Test Restore via Dry Run')
  .demand(1)
  .help()
  .version().argv

const command = argv._[0]

try {
  debug(`Executing ${command}`)
  require(path.join(__dirname, `../commands/${command}.js`))(argv)
} catch (err) {
  if (err.code === 'MODULE_NOT_FOUND') {
    console.log(chalk.red.bold(`\n✖ Command 'pdp ${command}' not recognized\n`))
    console.log('Use ' + chalk.cyan('mimic help') + ' for a list of commands\n')
  } else {
    throw err
  }
}