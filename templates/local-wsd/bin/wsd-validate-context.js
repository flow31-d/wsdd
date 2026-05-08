#!/usr/bin/env node
'use strict';

// WSD context.json validator — zero-deps minimal JSON Schema 2020-12 runner.
//
// Supported keywords: type, required, properties, additionalProperties,
// items, enum, const, pattern, minLength, maxLength, minimum, maximum, oneOf.
// Unsupported keywords (e.g. $ref, allOf, anyOf, not, definitions) raise
// `unsupported keyword` so the schema fails loudly instead of silently passing.
//
// Exit codes:
//   0  schema valid
//   1  schema violations found
//   2  IO/parse error (missing file, invalid JSON)
//   3  unsupported schema keyword

const fs = require('fs');
const path = require('path');

const SUPPORTED = new Set([
  '$schema', '$id', 'title', 'description',
  'type', 'required', 'properties', 'additionalProperties',
  'items', 'enum', 'const', 'pattern',
  'minLength', 'maxLength', 'minimum', 'maximum', 'oneOf'
]);

function main(argv) {
  const args = parseArgs(argv);
  if (args.help) {
    printHelp();
    process.exit(0);
  }
  if (!args.input) {
    console.error('FAIL: missing <path-to-context.json>');
    printHelp();
    process.exit(2);
  }
  const schemaPath = args.schema || defaultSchemaPath();
  if (!schemaPath) {
    console.error('FAIL: schema not found and --schema not provided');
    process.exit(2);
  }

  let schema;
  try {
    schema = JSON.parse(fs.readFileSync(schemaPath, 'utf8'));
  } catch (error) {
    console.error(`FAIL: cannot read schema ${schemaPath}: ${error.message}`);
    process.exit(2);
  }

  let document;
  try {
    document = JSON.parse(fs.readFileSync(args.input, 'utf8'));
  } catch (error) {
    console.error(`FAIL: cannot read ${args.input}: ${error.message}`);
    process.exit(2);
  }

  const errors = [];
  try {
    validate(document, schema, '', errors);
  } catch (error) {
    if (error.code === 'UNSUPPORTED_KEYWORD') {
      console.error(`FAIL: ${error.message}`);
      process.exit(3);
    }
    throw error;
  }

  if (errors.length > 0) {
    console.error(`FAIL: ${args.input} violates ${schemaPath}`);
    for (const err of errors) console.error(`  ${err.path || '/'}: ${err.message}`);
    process.exit(1);
  }
  console.log(`ok: ${args.input} schema valid`);
  process.exit(0);
}

function parseArgs(argv) {
  const out = { input: null, schema: null, help: false };
  for (let i = 0; i < argv.length; i += 1) {
    const a = argv[i];
    if (a === '-h' || a === '--help') out.help = true;
    else if (a === '--schema') { out.schema = argv[++i]; }
    else if (!a.startsWith('-')) { out.input = a; }
  }
  return out;
}

function printHelp() {
  console.log('Usage: wsd-validate-context.js <path-to-context.json> [--schema <path>]');
  console.log('');
  console.log('  Validates a .context.json against the WSD JSON Schema.');
  console.log('  Default schema: <script_dir>/../schemas/context.schema.json');
  console.log('');
  console.log('Exit codes: 0 ok, 1 schema fail, 2 IO/parse, 3 unsupported keyword');
}

function defaultSchemaPath() {
  const here = path.dirname(fs.realpathSync(process.argv[1]));
  const candidate = path.join(here, '..', 'schemas', 'context.schema.json');
  return fs.existsSync(candidate) ? candidate : null;
}

function validate(value, schema, ptr, errors) {
  if (schema === true) return;
  if (schema === false) {
    errors.push({ path: ptr, message: 'schema is false (no value allowed)' });
    return;
  }
  if (schema === null || typeof schema !== 'object') return;

  for (const key of Object.keys(schema)) {
    if (!SUPPORTED.has(key)) {
      const error = new Error(`unsupported keyword '${key}' at ${ptr || '/'}`);
      error.code = 'UNSUPPORTED_KEYWORD';
      throw error;
    }
  }

  if (schema.const !== undefined && !deepEqual(value, schema.const)) {
    errors.push({ path: ptr, message: `must equal ${JSON.stringify(schema.const)}, got ${JSON.stringify(value)}` });
    return;
  }

  if (schema.enum !== undefined) {
    if (!schema.enum.some((candidate) => deepEqual(candidate, value))) {
      errors.push({ path: ptr, message: `must be one of ${JSON.stringify(schema.enum)}, got ${JSON.stringify(value)}` });
      return;
    }
  }

  if (schema.type !== undefined && !matchesType(value, schema.type)) {
    errors.push({ path: ptr, message: `expected type '${schema.type}', got '${actualType(value)}'` });
    return;
  }

  if (typeof value === 'string') {
    if (schema.minLength !== undefined && value.length < schema.minLength) {
      errors.push({ path: ptr, message: `string length ${value.length} < minLength ${schema.minLength}` });
    }
    if (schema.maxLength !== undefined && value.length > schema.maxLength) {
      errors.push({ path: ptr, message: `string length ${value.length} > maxLength ${schema.maxLength}` });
    }
    if (schema.pattern !== undefined && !new RegExp(schema.pattern).test(value)) {
      errors.push({ path: ptr, message: `string does not match pattern ${schema.pattern}` });
    }
  }

  if (typeof value === 'number') {
    if (schema.minimum !== undefined && value < schema.minimum) {
      errors.push({ path: ptr, message: `number ${value} < minimum ${schema.minimum}` });
    }
    if (schema.maximum !== undefined && value > schema.maximum) {
      errors.push({ path: ptr, message: `number ${value} > maximum ${schema.maximum}` });
    }
  }

  if (Array.isArray(value) && schema.items !== undefined) {
    for (let i = 0; i < value.length; i += 1) {
      validate(value[i], schema.items, `${ptr}/${i}`, errors);
    }
  }

  if (isPlainObject(value)) {
    if (Array.isArray(schema.required)) {
      for (const key of schema.required) {
        if (!Object.prototype.hasOwnProperty.call(value, key)) {
          errors.push({ path: ptr, message: `missing required property '${key}'` });
        }
      }
    }
    if (schema.properties) {
      for (const key of Object.keys(schema.properties)) {
        if (Object.prototype.hasOwnProperty.call(value, key)) {
          validate(value[key], schema.properties[key], `${ptr}/${key}`, errors);
        }
      }
    }
    if (schema.additionalProperties === false && schema.properties) {
      const known = new Set(Object.keys(schema.properties));
      for (const key of Object.keys(value)) {
        if (!known.has(key)) {
          errors.push({ path: ptr, message: `additional property '${key}' not allowed` });
        }
      }
    } else if (isPlainObject(schema.additionalProperties) && schema.properties) {
      const known = new Set(Object.keys(schema.properties));
      for (const key of Object.keys(value)) {
        if (!known.has(key)) {
          validate(value[key], schema.additionalProperties, `${ptr}/${key}`, errors);
        }
      }
    }
  }

  if (Array.isArray(schema.oneOf)) {
    let matches = 0;
    const subErrors = [];
    for (const sub of schema.oneOf) {
      const localErrors = [];
      validate(value, sub, ptr, localErrors);
      if (localErrors.length === 0) matches += 1;
      else subErrors.push(localErrors);
    }
    if (matches !== 1) {
      errors.push({ path: ptr, message: `oneOf matched ${matches} schemas (must be exactly 1)` });
    }
  }
}

function matchesType(value, type) {
  if (Array.isArray(type)) return type.some((t) => matchesType(value, t));
  switch (type) {
    case 'string': return typeof value === 'string';
    case 'number': return typeof value === 'number' && !Number.isNaN(value);
    case 'integer': return typeof value === 'number' && Number.isInteger(value);
    case 'boolean': return typeof value === 'boolean';
    case 'null': return value === null;
    case 'array': return Array.isArray(value);
    case 'object': return isPlainObject(value);
    default: return false;
  }
}

function actualType(value) {
  if (value === null) return 'null';
  if (Array.isArray(value)) return 'array';
  if (typeof value === 'number' && Number.isInteger(value)) return 'integer';
  return typeof value;
}

function isPlainObject(value) {
  return value !== null && typeof value === 'object' && !Array.isArray(value);
}

function deepEqual(a, b) {
  if (a === b) return true;
  if (typeof a !== typeof b) return false;
  if (a === null || b === null) return false;
  if (Array.isArray(a) && Array.isArray(b)) {
    if (a.length !== b.length) return false;
    return a.every((item, i) => deepEqual(item, b[i]));
  }
  if (typeof a === 'object' && typeof b === 'object') {
    const keysA = Object.keys(a);
    const keysB = Object.keys(b);
    if (keysA.length !== keysB.length) return false;
    return keysA.every((k) => deepEqual(a[k], b[k]));
  }
  return false;
}

main(process.argv.slice(2));
