/*
 * Copyright (C) 2021 LingmoOS Team.
 *
 * Author:     Reion Wong <reionwong@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "utils.h"
#include <QApplication>
#include <QClipboard>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QHash>
#include <QSet>

#include <algorithm>
#include <pwd.h>
#include <unistd.h>

static Utils *SELF = nullptr;

Utils *Utils::self()
{
    if (!SELF)
        SELF = new Utils;

    return SELF;
}

Utils::Utils(QObject *parent)
    : QObject(parent)
{

}

QString Utils::text() const
{
    return qApp->clipboard()->text();
}

QString Utils::defaultShell() const
{
    const QString env = QString::fromLocal8Bit(qgetenv("SHELL"));
    if (isUsableShell(env))
        return env;

    if (const struct passwd *pw = getpwuid(getuid())) {
        const QString login = QString::fromLocal8Bit(pw->pw_shell);
        if (isUsableShell(login))
            return login;
    }

    return QStringLiteral("/bin/bash");
}

bool Utils::isUsableShell(const QString &path) const
{
    if (path.isEmpty() || !QDir::isAbsolutePath(path))
        return false;

    const QFileInfo info(path);
    return info.exists() && info.isFile() && info.isExecutable();
}

QString Utils::shellName(const QString &path) const
{
    static const QHash<QString, QString> names = {
        { QStringLiteral("bash"), QStringLiteral("Bash") },
        { QStringLiteral("zsh"), QStringLiteral("Zsh") },
        { QStringLiteral("fish"), QStringLiteral("Fish") },
        { QStringLiteral("dash"), QStringLiteral("Dash") },
        { QStringLiteral("sh"), QStringLiteral("sh") },
        { QStringLiteral("nu"), QStringLiteral("Nushell") },
        { QStringLiteral("ksh"), QStringLiteral("KornShell") },
        { QStringLiteral("mksh"), QStringLiteral("MirBSD Korn Shell") },
        { QStringLiteral("oksh"), QStringLiteral("OpenBSD Korn Shell") },
        { QStringLiteral("csh"), QStringLiteral("C shell") },
        { QStringLiteral("tcsh"), QStringLiteral("Tcsh") },
        { QStringLiteral("xonsh"), QStringLiteral("Xonsh") },
        { QStringLiteral("elvish"), QStringLiteral("Elvish") },
        { QStringLiteral("pwsh"), QStringLiteral("PowerShell") },
        { QStringLiteral("yash"), QStringLiteral("Yash") },
        { QStringLiteral("ion"), QStringLiteral("Ion") },
        { QStringLiteral("oil"), QStringLiteral("Oils") },
        { QStringLiteral("osh"), QStringLiteral("Oils (osh)") },
        { QStringLiteral("ysh"), QStringLiteral("Oils (ysh)") },
        { QStringLiteral("murex"), QStringLiteral("Murex") },
        { QStringLiteral("busybox"), QStringLiteral("BusyBox") },
        { QStringLiteral("ash"), QStringLiteral("Almquist shell") },
    };

    const QString base = QFileInfo(path).fileName();
    if (names.contains(base))
        return names.value(base);
    if (base.isEmpty())
        return path;
    return base.at(0).toUpper() + base.mid(1);
}

QVariantList Utils::availableShells() const
{
    // Not meant for an interactive terminal: they exit at once or refuse commands
    static const QSet<QString> excluded = {
        QStringLiteral("nologin"), QStringLiteral("false"), QStringLiteral("true"),
        QStringLiteral("git-shell"), QStringLiteral("rbash"), QStringLiteral("rzsh"),
        QStringLiteral("rksh"), QStringLiteral("scponly"), QStringLiteral("rssh"),
        QStringLiteral("systemd-home-fallback-shell"),
    };

    QFile file(QStringLiteral("/etc/shells"));
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return {};

    // One entry per real binary, so /bin/zsh and /usr/bin/zsh (and sh when it
    // is just a link to bash or dash) show up once
    QStringList paths;

    while (!file.atEnd()) {
        const QString line = QString::fromLocal8Bit(file.readLine()).trimmed();
        if (line.isEmpty() || line.startsWith(QLatin1Char('#')) || !isUsableShell(line))
            continue;

        const QFileInfo entry(line);
        if (excluded.contains(entry.fileName()))
            continue;

        const QString real = entry.canonicalFilePath();
        const QString realName = QFileInfo(real).fileName();
        if (real.isEmpty() || excluded.contains(realName))
            continue;

        // Run the real binary, except for multi-call binaries such as
        // busybox, which pick the applet from the name they were run as
        QString path = real;
        if (realName == QLatin1String("busybox"))
            path = QFileInfo(entry.canonicalPath(), entry.fileName()).filePath();

        if (!paths.contains(path))
            paths << path;
    }

    QVariantList result;
    for (const QString &path : std::as_const(paths)) {
        QVariantMap shell;
        shell.insert(QStringLiteral("name"), shellName(path));
        shell.insert(QStringLiteral("path"), path);
        result << shell;
    }

    std::sort(result.begin(), result.end(), [](const QVariant &a, const QVariant &b) {
        return a.toMap().value(QStringLiteral("name")).toString().compare(
                   b.toMap().value(QStringLiteral("name")).toString(), Qt::CaseInsensitive) < 0;
    });

    return result;
}
