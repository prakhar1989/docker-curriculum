document.addEventListener('DOMContentLoaded', () => {
	initCopyButtons();
});

document.addEventListener('astro:page-load', () => {
	initCopyButtons();
});

// Also run immediately if DOM is already loaded
if (document.readyState !== 'loading') {
	initCopyButtons();
}

function initCopyButtons() {
	const codeBlocks = document.querySelectorAll('pre');

	codeBlocks.forEach((pre) => {
		if (pre.getAttribute('data-copy-button') === 'true') return;
		pre.setAttribute('data-copy-button', 'true');

		// Create copy button element
		const button = document.createElement('button');
		button.type = 'button';
		button.className = 'copy-code-button';
		button.setAttribute('aria-label', 'Copy code to clipboard');

		const copyIcon = `<svg viewBox="0 0 24 24"><path d="M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12V1zm3 4H8c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h11c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm0 16H8V7h11v14z"/></svg>`;
		const checkIcon = `<svg viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>`;

		button.innerHTML = `${copyIcon}`;

		button.addEventListener('click', async () => {
			const code = pre.querySelector('code');
			let textToCopy = code ? code.innerText : pre.innerText;
			// Strip any trailing whitespace/newlines
			textToCopy = textToCopy.trim();

			try {
				await navigator.clipboard.writeText(textToCopy);
				button.classList.add('copied');
				button.innerHTML = `${checkIcon}<span>Copied!</span>`;

				setTimeout(() => {
					button.classList.remove('copied');
					button.innerHTML = `${copyIcon}<span>Copy</span>`;
				}, 2000);
			} catch (err) {
				console.error('Failed to copy code: ', err);
			}
		});

		pre.appendChild(button);
	});
}
