1.0.0 (2025-11-03)
------------------
- Upgrade ensurepip module on pip upgrade, mostly to fix pip issues on Pthon 3.12
- [Breaking] Drop supports for Chef 16 and under.

0.1.6 (2023-10-03)
------------------
- Fix Python package validation regex to support multi-digits minor version (i.e. >= 10)

0.1.5 (2023-01-27)
------------------
- Use ensurepip to bootstrap pip install
- Use pip module (and not get-pip) to upgrade pip
- Use venv module to create virtualenv

0.1.4 (2023-01-04)
------------------
- Fix PIP installation

0.1.3 (2022-10-24)
------------------
- Fix Python package validation regex to support both python39 and python3.9

0.1.2 (2022-10-21)
------------------
- Fix Python version used when creating a virtualenv
- Support different pip binary names

0.1.1 (2022-10-20)
------------------
- Better support of non-default python versions

0.1.0 (2022-09-12)
------------------
- Initial release of python3 cookbook
