const vscode = require('vscode');

/**
 * @param {vscode.ExtensionContext} context
 */
function activate(context) {
    vscode.window.showInformationMessage('ACC Agents extension activated!');

    let disposable = vscode.commands.registerCommand('accAgents.install', function () {
        vscode.window.showInformationMessage('ACC Agents installed successfully!');
    });

    context.subscriptions.push(disposable);
}

function deactivate() {}

module.exports = {
    activate,
    deactivate
};