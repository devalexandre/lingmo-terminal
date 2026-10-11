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

#ifndef UTILS_H
#define UTILS_H

#include <QObject>
#include <QVariantList>

class Utils : public QObject
{
    Q_OBJECT

public:
    static Utils *self();
    explicit Utils(QObject *parent = nullptr);

    Q_INVOKABLE QString text() const;

    // The user's login shell: $SHELL, then the passwd entry, then /bin/bash.
    // This is what the terminal runs when no shell is chosen in the settings.
    Q_INVOKABLE QString defaultShell() const;

    // Interactive shells listed in /etc/shells, as [{ name, path }].
    // Only existing executables, one entry per real binary (/bin -> /usr/bin
    // and sh -> bash links collapse), restricted/non-login shells left out.
    Q_INVOKABLE QVariantList availableShells() const;

    // Friendly name for a shell path ("/usr/bin/zsh" -> "Zsh")
    Q_INVOKABLE QString shellName(const QString &path) const;

    // An absolute path to an executable file
    Q_INVOKABLE bool isUsableShell(const QString &path) const;
};

#endif // UTILS_H
