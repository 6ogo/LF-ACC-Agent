import * as vscode from 'vscode';
import * as fs from 'fs';
import * as path from 'path';

export function activate(context: vscode.ExtensionContext) {
  let disposable = vscode.commands.registerCommand('accAgents.install', async () => {
    const workspaceFolders = vscode.workspace.workspaceFolders;
    if (!workspaceFolders) {
      vscode.window.showErrorMessage('No workspace folder open.');
      return;
    }
    const root = workspaceFolders[0].uri.fsPath;
    const agentSrc = context.asAbsolutePath('agents');
    const skillsSrc = context.asAbsolutePath('skills');
    const docsSrc = context.asAbsolutePath('commands');
    const agentDest = path.join(root, 'agents');
    const skillsDest = path.join(root, 'skills');
    const docsDest = path.join(root, 'commands');
    copyFolderRecursiveSync(agentSrc, agentDest);
    copyFolderRecursiveSync(skillsSrc, skillsDest);
    copyFolderRecursiveSync(docsSrc, docsDest);
    vscode.window.showInformationMessage('ACC Agents and skills installed to workspace.');
  });
  context.subscriptions.push(disposable);
}

function copyFolderRecursiveSync(src: string, dest: string) {
  if (!fs.existsSync(src)) return;
  if (!fs.existsSync(dest)) fs.mkdirSync(dest, { recursive: true });
  for (const item of fs.readdirSync(src)) {
    const srcPath = path.join(src, item);
    const destPath = path.join(dest, item);
    if (fs.lstatSync(srcPath).isDirectory()) {
      copyFolderRecursiveSync(srcPath, destPath);
    } else {
      fs.copyFileSync(srcPath, destPath);
    }
  }
}

export function deactivate() {}
