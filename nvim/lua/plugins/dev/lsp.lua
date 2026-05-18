return {
	require("lspconfig").terraformls.setup({
		settings = {
			terraform = {
				validate = {
					enable = false,
				},
			},
		},
	}),
}
