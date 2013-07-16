
Name:           bash-modules
Version:        2.0.2
Release:        1%{?dist}
Summary:        Modules for bash

Group:          System Environment/Base
URL:            http://trac.assembla.com/bash-modules/
License:        LGPLv2.1+
Source0:        %{name}.tar.gz
BuildArch:      noarch
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

#BuildRequires:
Requires:       bash

# For arguments module, for built-in documentation to workd
Requires:       perl
Requires:       perl-Pod-Perldoc

%define  homedir /usr/share/bash-modules

%description
Optional modules to use with bash, like logging, argument parsing, etc.

%prep
%setup -q -n %{name}


%build
# Nothing to do

# Execute tests
(
  cd test
  exec /bin/bash ./test.sh -q
)

%install
rm -rf "$RPM_BUILD_ROOT"

install -D src/import.sh "$RPM_BUILD_ROOT%_bindir/import.sh"

mkdir -p "$RPM_BUILD_ROOT%homedir/"
cp -a src/bash-modules/* "$RPM_BUILD_ROOT%homedir/"

%clean
rm -rf "$RPM_BUILD_ROOT"


%files
%defattr(644,root,root,755)
%doc COPYING* README Changelog doc/

%attr(0755,root,root) %_bindir/import.sh
%homedir


%changelog
* Tue Jul 16 2013 Volodymyr M. Lisivka <vlisivka@gmail.com> - 2.0.2-2
- License tag changed from LGPL to LGPL2.1+
