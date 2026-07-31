export type ThemeMode = 'dark' | 'light';

export interface Palette {
	id: string;
	name: string;
	mode: ThemeMode;
	description: string;
	accent: string;
}

export const palettes: Palette[] = [
	{
		id: 'deep-ocean',
		name: 'Deep Ocean',
		mode: 'dark',
		description: 'Docker blue on a deep navy canvas.',
		accent: '#58c7f3',
	},
	{
		id: 'engine-room',
		name: 'Engine Room',
		mode: 'dark',
		description: 'Charcoal surfaces with a green terminal accent.',
		accent: '#72d6a4',
	},
	{
		id: 'midnight-compose',
		name: 'Midnight Compose',
		mode: 'dark',
		description: 'Indigo panels with a cool cyan signal.',
		accent: '#9aa9ff',
	},
	{
		id: 'cloud',
		name: 'Cloud',
		mode: 'light',
		description: 'The crisp, bright Docker default.',
		accent: '#087ea4',
	},
	{
		id: 'blueprint',
		name: 'Blueprint',
		mode: 'light',
		description: 'Cool paper tones for long reading sessions.',
		accent: '#315fc4',
	},
	{
		id: 'paper',
		name: 'Paper',
		mode: 'light',
		description: 'A warmer, softer tutorial workspace.',
		accent: '#a35f28',
	},
];

export const defaultPalette = palettes[0];
export const defaultLightPalette = palettes.find(({ mode }) => mode === 'light') ?? palettes[0];
