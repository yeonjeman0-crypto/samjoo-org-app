// ============================================================
// db.js  ·  Shared SQLite connection (Node 22+ built-in)
// Run node with --experimental-sqlite flag
// ============================================================
const path = require('path');
const Database = require('better-sqlite3');

const DB_PATH = path.resolve(__dirname, '..', 'db', 'orgchart.db');
const db = new Database(DB_PATH);
db.exec('PRAGMA journal_mode = WAL');
db.exec('PRAGMA foreign_keys = ON');

module.exports = db;
