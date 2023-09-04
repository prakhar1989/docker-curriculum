import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
	integrations: [
		starlight({
			title: 'Docker Curriculum',
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
					label: 'Conclusion',
					autogenerate: { directory: 'conclusion' },
				},
			],
		}),
	],

	// Process images with sharp: https://docs.astro.build/en/guides/assets/#using-sharp
	image: { service: { entrypoint: 'astro/assets/services/sharp' } },
});
