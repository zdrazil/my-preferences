/**
 * pi-params — Generation parameter control for Pi
 *
 * Set temperature, top_p, max_tokens, and other model params per conversation.
 * Hooks into pre_request to inject parameters before API calls.
 *
 * Commands:
 *   /params                        — show current overrides
 *   /params set <key> <value>      — set a parameter
 *   /params reset                  — clear all overrides
 *   /params preset <name>          — apply a preset (general, coding, creative, precise, balanced, brainstorm, long)
 *
 * Examples:
 *   /params set temperature 0.9    — more creative
 *   /params set temperature 0.1    — more deterministic
 *   /params set top_p 0.5          — nucleus sampling
 *   /params set max_tokens 8192    — longer responses
 *   /params preset creative        — temp 1.0, top_p 0.95
 *   /params preset precise         — temp 0.1, top_p 0.1
 *   /params preset general         — general purpose (temp 1.0, top_k 20)
 *   /params preset coding          — coding focused (temp 0.6, top_k 20)
 *   /params preset creative        — high creativity (temp 1.0, top_p 0.95)
 *   /params preset precise         — maximum precision (temp 0.1, top_p 0.1)
 */

import type { ExtensionAPI } from '@earendil-works/pi-coding-agent'
import { Type } from 'typebox'

interface ParamOverrides {
    temperature?: number
    top_p?: number
    top_k?: number
    max_tokens?: number
    frequency_penalty?: number
    presence_penalty?: number
    repetition_penalty?: number
    stop?: string[],
    min_p?: number
}

const PRESETS: Record<string, { params: ParamOverrides; description: string }> = {
    general: {
        params: { temperature: 1.0, top_p: 0.95, top_k: 20, min_p: 0, presence_penalty:0.0, repetition_penalty: 1.0 },
        description: 'General — temperature: 1.0, top_p: 0.95, top_k: 20, min_p: 0',
    },
    coding: {
        params: { temperature: 0.6, top_p: 0.95, top_k: 20, min_p: 0, presence_penalty:0.0, repetition_penalty: 1.0 },
        description: 'Coding — temperature: 0.6, top_p: 0.95, top_k: 20, min_p: 0',
    },
    creative: {
        params: { temperature: 1.0, top_p: 0.95 },
        description: 'High creativity — temperature 1.0, top_p 0.95',
    },
    precise: {
        params: { temperature: 0.1, top_p: 0.1 },
        description: 'Maximum precision — temperature 0.1, top_p 0.1',
    },
    balanced: {
        params: { temperature: 0.5, top_p: 0.8 },
        description: 'Balanced — temperature 0.5, top_p 0.8',
    },
    // code: {
        // params: { temperature: 0.2, top_p: 0.5 },
        // description: 'Code generation — temperature 0.2, top_p 0.5',
    // },
    brainstorm: {
        params: { temperature: 1.2, top_p: 0.95, frequency_penalty: 0.5 },
        description: 'Brainstorming — temperature 1.2, top_p 0.95, frequency_penalty 0.5',
    },
    long: {
        params: { max_tokens: 16384 },
        description: 'Long output — max_tokens 16384',
    },
}

const overrides: ParamOverrides = {}
let activePreset: string | null = null

function formatStatus(): string {
    const keys = Object.keys(overrides).filter(k => (overrides as any)[k] !== undefined)

    if (keys.length === 0) {
        return '## pi-params\n\nNo overrides active. Using model defaults.\n\n**Presets:** ' +
            Object.entries(PRESETS).map(([k, v]) => `\`${k}\` (${v.description})`).join(', ')
    }

    const lines = ['## pi-params', '']
    if (activePreset) lines.push(`**Preset:** ${activePreset}`)
    lines.push('**Active overrides:**')
    for (const k of keys) {
        const val = (overrides as any)[k]
        lines.push(`- \`${k}\`: ${JSON.stringify(val)}`)
    }
    lines.push('', '`/params reset` to clear all.')
    return lines.join('\n')
}

function setParam(key: string, value: string): string {
    const numericKeys = ['temperature', 'top_p', 'max_tokens', 'frequency_penalty', 'presence_penalty']
    const validKeys = [...numericKeys, 'stop']

    if (!validKeys.includes(key)) {
        return `Unknown parameter "${key}". Valid: ${validKeys.join(', ')}`
    }

    if (key === 'stop') {
        (overrides as any).stop = value.split(',').map(s => s.trim())
    } else {
        const num = parseFloat(value)
        if (isNaN(num)) return `"${value}" is not a valid number.`

        if (key === 'temperature' && (num < 0 || num > 2)) return 'Temperature must be 0-2.'
        if (key === 'top_p' && (num < 0 || num > 1)) return 'top_p must be 0-1.'
        if (key === 'max_tokens' && (num < 1 || num > 200000)) return 'max_tokens must be 1-200000.'
        if ((key === 'frequency_penalty' || key === 'presence_penalty') && (num < -2 || num > 2)) return `${key} must be -2 to 2.`

            ; (overrides as any)[key] = num
    }

    activePreset = null
    return `Set **${key}** = ${(overrides as any)[key]}`
}

function applyPreset(name: string): string {
    const preset = PRESETS[name]
    if (!preset) {
        return `Unknown preset "${name}". Available: ${Object.keys(PRESETS).join(', ')}`
    }

    // Clear existing
    for (const k of Object.keys(overrides)) {
        delete (overrides as any)[k]
    }

    // Apply preset
    Object.assign(overrides, preset.params)
    activePreset = name
    return `Applied preset **${name}**: ${preset.description}`
}

function resetParams(): string {
    for (const k of Object.keys(overrides)) {
        delete (overrides as any)[k]
    }
    activePreset = null
    return 'All parameter overrides cleared. Using model defaults.'
}

export default function init(pi: ExtensionAPI) {
    // Hook into before_provider_request to inject params
    pi.on('before_provider_request', (event: any) => {
        const keys = Object.keys(overrides).filter(k => (overrides as any)[k] !== undefined)
        if (keys.length === 0) return

        const payload = event.payload
        if (payload && typeof payload === 'object') {
            for (const k of keys) {
                (payload as any)[k] = (overrides as any)[k]
            }
        }
        return payload
    })

    // Command
    pi.registerCommand('params', {
        description: 'Control generation parameters (temperature, top_p, max_tokens)',
        handler: async (args, ctx) => {
            const parts = args.trim().split(/\s+/)
            const sub = parts[0]?.toLowerCase()

            if (!sub || sub === 'status') {
                ctx.ui.notify(formatStatus(), 'info')
                return
            }

            if (sub === 'set') {
                const key = parts[1]
                const value = parts[2]
                if (!key || !value) {
                    ctx.ui.notify('Usage: /params set <key> <value>\n\nKeys: temperature, top_p, max_tokens, frequency_penalty, presence_penalty, stop', 'info')
                    return
                }
                const result = setParam(key, value)
                ctx.ui.notify(result, 'info')
                return
            }

            if (sub === 'preset') {
                const name = parts[1]
                if (!name) {
                    const presetList = Object.entries(PRESETS).map(([k, v]) => `- \`${k}\`: ${v.description}`).join('\n')
                    ctx.ui.notify(`**Available presets:**\n${presetList}`, 'info')
                    return
                }
                const result = applyPreset(name)
                ctx.ui.notify(result, 'info')
                return
            }

            if (sub === 'reset') {
                const result = resetParams()
                ctx.ui.notify(result, 'info')
                return
            }

            ctx.ui.notify(
                '**Usage:**\n- `/params` — show current overrides\n- `/params set <key> <value>` — set parameter\n- `/params preset <name>` — apply preset\n- `/params reset` — clear all',
                'info'
            )
        },
    })

    // Tools
    pi.registerTool({
        name: 'params_set',
        label: 'Params Set',
        description: 'Set a generation parameter (temperature, top_p, max_tokens, frequency_penalty, presence_penalty).',
        parameters: Type.Object({
            key: Type.String({ description: 'Parameter name' }),
            value: Type.String({ description: 'Parameter value' }),
        }),
        async execute(_toolCallId, params) {
            return {
                content: [{ type: 'text', text: setParam(params.key, params.value) }],
                details: {},
            }
        },
    })

    pi.registerTool({
        name: 'params_preset',
        label: 'Params Preset',
        description: 'Apply a generation preset: general (temp 1.0), coding (temp 0.6), creative (temp 1.0), precise (temp 0.1), balanced (temp 0.5), brainstorm (temp 1.2), long (max_tokens 16384).',
        parameters: Type.Object({
            name: Type.String({ enum: ['general', 'coding', 'creative', 'precise', 'balanced', 'brainstorm', 'long'], description: 'Preset name' }),
        }),
        async execute(_toolCallId, params) {
            return {
                content: [{ type: 'text', text: applyPreset(params.name) }],
                details: {},
            }
        },
    })

    pi.registerTool({
        name: 'params_status',
        label: 'Params Status',
        description: 'Show current generation parameter overrides.',
        parameters: Type.Object({}),
        async execute(_toolCallId) {
            return {
                content: [{ type: 'text', text: formatStatus() }],
                details: {},
            }
        },
    })
}
