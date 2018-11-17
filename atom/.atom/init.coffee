# Add any auto-loaded Atom code on init here.

atom.commands.add 'atom-workspace', 'custom:close': ->
    panes = atom.workspace.getPanes()
    pane.destroy() for pane in panes
    atom.close()
