import setuptools

with open("README.md") as fp:
    long_description = fp.read()

setuptools.setup(
    name="tgw_vpn_monitoring",
    version="0.1.0",
    description="Transit Gateway VPN Monitoring CDK Project",
    long_description=long_description,
    long_description_content_type="text/markdown",
    author="AWS",
    package_dir={"": "."},
    packages=setuptools.find_packages(),
    install_requires=[
        "aws-cdk-lib>=2.0.0",
        "constructs>=10.0.0",
        "boto3>=1.28.0",
    ],
    python_requires=">=3.9",
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "Programming Language :: Python :: 3 :: Only",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Topic :: Software Development :: Code Generators",
        "Topic :: Utilities",
        "Typing :: Typed",
    ],
)
