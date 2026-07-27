import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
	integrations: [
		starlight({
			title: 'Docker Curriculum',
			tableOfContents: false,
			customCss: ['./src/styles/custom.css'],
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
			social: {
				github: 'https://github.com/prakhar1989/docker-curriculum',
			},
			editLink: {
				baseUrl: 'https://github.com/prakhar/docker-curriculum/edit/main/starlight/',
			},
			sidebar: [
				{
					label: 'Introduction',
					autogenerate: { directory: 'introduction' },
				},
				{
					label: 'Getting Started',
					autogenerate: { directory: 'getting-started' },
				},
				{
					label: 'Hello World',
					autogenerate: { directory: 'hello-world' },
				},
				{
					label: 'Webapps with Docker',
					autogenerate: { directory: 'webapps-with-docker' },
				},
				{
					label: 'Multi-Container Environments',
					autogenerate: { directory: 'multi-container-environments' },
				},
				{
					label: 'Modern Docker & Best Practices',
					autogenerate: { directory: 'modern-docker' },
				},
				{
					label: 'Conclusion',
					autogenerate: { directory: 'conclusion' },
				},
			],
		}),
	],

	// Process images with sharp: https://docs.astro.build/en/guides/assets/#using-sharp
	image: { service: { entrypoint: 'astro/assets/services/sharp' } },
});
