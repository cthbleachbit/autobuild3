#!/bin/bash
##30-path_issues: Check for incorrectly installed paths.
##@copyright GPL-2.0+

[ -e "$PKGDIR"/usr/local ] && abdie "QA: found \$PKGDIR/usr/local."

