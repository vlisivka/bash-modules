
Name:           bash-modules-tui
Version:        2.0.2
Release:        3%{?dist}
Summary:        Modules for bash to implement basic TUI

Group:          System/Libraries
URL:            https://github.com/vlisivka/bash-modules
License:        LGPL-2.1+
Source0:        %{name}.tar.gz
BuildArch:      noarch
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

#BuildRequires:  bash-modules
Requires:       bash
Requires:       bash-modules

%define  homedir /usr/share/bash-modules

%description
Optional modules to use with bash to implement basic text mode interface.

%prep
%setup -q -n %{name}


%build
# Nothing to do
#(
#  cd test
#  exec /bin/bash ./test.sh -q
#)

%install
rm -rf "$RPM_BUILD_ROOT"


mkdir -p "$RPM_BUILD_ROOT%homedir/"
cp -a src/bash-modules/* "$RPM_BUILD_ROOT%homedir/"

%clean
rm -rf "$RPM_BUILD_ROOT"


%files
%defattr(644,root,root,755)
%doc COPYING* README Changelog doc/

%homedir


%changelog
* Wed Jul 31 2013 Volodymyr M. Lisivka <vlisivka@gmail.com> - 2.0.2-4
- Group changed again from to "System/Libraries"
- URL to home page is changed to github

* Mon Jul 29 2013 Volodymyr M. Lisivka <vlisivka@gmail.com> - 2.0.2-3
- Group changed from "System Environment/Base" to "Development/Libraries/Bash"

* Tue Jul 16 2013 Volodymyr M. Lisivka <vlisivka@gmail.com> - 2.0.2-2
- License tag changed from LGPL to LGPL2.1+
