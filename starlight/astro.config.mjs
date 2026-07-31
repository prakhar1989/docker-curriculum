import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
	site: 'https://docker-curriculum.com',
	integrations: [
		starlight({
			title: 'Docker Curriculum',
			tableOfContents: false,
			customCss: ['./src/styles/custom.css', './src/styles/design.css'],
			components: {
				ThemeProvider: './src/components/ThemeProvider.astro',
				ThemeSelect: './src/components/ThemeSelect.astro',
			},
			head: [
				{
					tag: 'script',
					attrs: {
						src: '/copy-code.js',
						defer: true,
					},
				},
				{
					tag: 'script',
					attrs: {
						src: 'https://static.cloudflareinsights.com/beacon.min.js',
						defer: true,
						'data-cf-beacon': '{"token": "458cd0b4cea74ace9f017c2380cb1b50"}',
					},
				},
			],
			social: [
				{
					icon: 'github',
					label: 'GitHub',
					href: 'https://github.com/prakhar1989/docker-curriculum',
				},
			],
			editLink: {
				baseUrl: 'https://github.com/prakhar/docker-curriculum/edit/main/starlight/',
			},
			sidebar: [
				{
					label: 'Introduction',
					items: [{ autogenerate: { directory: 'introduction' } }],
				},
				{
					label: 'Getting Started',
					items: [{ autogenerate: { directory: 'getting-started' } }],
				},
				{
					label: 'Hello World',
					items: [{ autogenerate: { directory: 'hello-world' } }],
				},
				{
					label: 'Webapps with Docker',
					items: [{ autogenerate: { directory: 'webapps-with-docker' } }],
				},
				{
					label: 'Multi-Container Environments',
					items: [{ autogenerate: { directory: 'multi-container-environments' } }],
				},
				{
					label: 'Modern Docker & Best Practices',
					items: [{ autogenerate: { directory: 'modern-docker' } }],
				},
				{
					label: 'Conclusion',
					items: [{ autogenerate: { directory: 'conclusion' } }],
				},
			],
		}),
	],

	// Process images with sharp: https://docs.astro.build/en/guides/assets/#using-sharp
	image: { service: { entrypoint: 'astro/assets/services/sharp' } },
});
