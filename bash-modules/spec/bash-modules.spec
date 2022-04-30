
Name:           bash-modules
Version:        4.0.1
Release:        1%{?dist}
Summary:        Modules for bash

Group:          System Environment/Libraries
URL:            https://github.com/vlisivka/bash-modules
License:        LGPL-2.1+
Source0:        %{name}.tar.gz
BuildArch:      noarch

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
install -D src/import.sh "$RPM_BUILD_ROOT%_bindir/import.sh"

mkdir -p "$RPM_BUILD_ROOT%homedir/"
cp -a src/bash-modules/* "$RPM_BUILD_ROOT%homedir/"

%clean
rm -rf "$RPM_BUILD_ROOT"

%files
%defattr(644,root,root,755)
%doc COPYING* README.md examples/

%attr(0755,root,root) %_bindir/import.sh
%homedir


%changelog
