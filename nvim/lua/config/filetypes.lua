vim.filetype.add({
	pattern = {
		[".*/playbooks/.*%.yml"] = "yaml.ansible",
		[".*/roles/.*/tasks/.*%.yml"] = "yaml.ansible",
	},
})
