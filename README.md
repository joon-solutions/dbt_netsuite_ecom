# Overview
- Provides transformation for raw tables extracted from Netsuite via Stitch, to reduce engineer hours arising from exploring and developing models for Netsuite data
- Enable data team to be exposed to the specification of Netsuite data, and transformations need to be implemented to create final marts table for analysis and reporting purposes
- Provide detailed logic for a specific use case, instead of general transformations like the Fivetran [package](https://github.com/fivetran/dbt_netsuite_source)(https://github.com/fivetran/dbt_netsuite_source). BE CAUTIOUS when using the package in your projects, and take into account the Loader (Stitch), use cases, and type of business (e-commerce or trading companies).
- Generates data dictionary of your source and modeled Netsuite data through the dbt docs site. The list of fields in Netsuite tables is varied depending on how the platform is configured. Not all of the fields in this package can be found in the same Netsuite modules implemented in other companies. Be sure to reach out to the Netsuite champion in the organization for more information. [Link](https://joon-solutions.github.io/dbt_netsuite_ecom/) to doc site.

# Use case
- The package is originally designed for an e-commerce company. The company is a startup growing rapidly and selling its products in different countries. They have plenty of subsidiaries and customers from different states of the US and Canada.
- Apart from being the main accounting system, Netsuite is used for inventory management. Inventories are distributed to customers via nearby subsidiaries. At the end of each financial year (FY), the accounting and finance department needs to consolidate financial reports from different subsidiaries, reported in different currencies to generate the consolidated financial report, including parent and all subsidiaries' financial figures.
- One of the tasks of the finance team is to prepare budgets for upcoming FYs. The budget can be allocated to different types of business units such as items, departments, accounts or accounting periods.
- As stated in the "Overview" section, rather than providing a general transformation, the package focuses on specific use cases for an e-commerce or trading company, which is to control their accounting transactions, and dimensional analysis around the transactions and budgets. The final objective is to create a set of mart tables that can support self-serve analytics for accounting and finance teams.

# User manual

## Step 1. Prerequisites
To use this package, you must have At least one Netsuite connector syncing the respective tables to your destination via Stitch:

- customer
- customersubsidiaryrelationship
- deletedrecord
- transaction
- item
- budgets
- transactionline
- account
- department
- classification
- consolidatedexchangerate
- customlist_weight_units
- subsidiary
- transactionaccountingline
- entity
- entitystatus
- entityaddress
- accountingperiod
- budgetsmachine
- itemunit
- accounttype
- currency


### Database Compatibility
Currently, This package is compatible with Snowflake only


## Step 2: Install the package
Include the following package version in your packages.yml file. The package has not been published to dbt [hub](https://hub.getdbt.com/) and can be accessed via importing a git repository, hosted in Github server.
> TIP: [Read the dbt docs](https://docs.getdbt.com/docs/build/packages) for more information on installing packages.

```yaml
packages:
  - git: "https://github.com/joon-solutions/dbt_netsuite_ecom.git" # git URL
    revision: main # tag or branch name
```

## Step 3: Define Database credentials
To use the package, you need to declare the below variables as environment variables in your local machine or the servers where dbt is deployed:
- DBT_ACCOUNT: Snowflake account hosted on a cloud platform in a geographical region
- DBT_USER: username to use for connecting to Snowflake
- DBT_PASSWORD: password to use for connecting to Snowflake
- DBT_ROLE: role to access into database and schema
- DBT_DB: database to output dbt models to
- DBT_WH: warehouse to process run of dbt models
- DBT_SCHEMA: schema to output dbt models to

> TIP: [Read the dbt docs](https://docs.getdbt.com/docs/core/connect-data-platform/snowflake-setup) for more information on specifying Snowflake's credentials

## Step 4: Define database and schema variables
By default, this package runs using your `raw` database the `netsuite_suite_analytics_prod` schema. If this is not where your Netsuite data is (for example, if your Netsuite schema is named `netsuite_abc`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
    nestuite_source_database: your_destination_name
    nestuite_source_schema: your_schema_name 
```

# Does this package have dependencies?
This dbt package is dependent on the following dbt packages. Please be aware that these dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.
    
```yml
packages:
    - package: dbt-labs/dbt_utils
      version: [">=1.1.0", "<2.0.0"]

```

# Glossary
The section includes terms used in the package.
- PII (Personal Identifiable Information): Any representation of information that permits the identity of an individual to whom the information applies to be reasonably inferred by either direct or indirect means.
- CARs (Confidential Accounting Records): financial data that contain sensitive information about a company's financial transactions, accounts, budgets, and other related information. 

# How is this package maintained?
The Joon team maintaining this package _only_ maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://github.com/joon-solutions/dbt_netsuite_ecom) of the package and refer to the [CHANGELOG](https://github.com/joon-solutions/dbt_netsuite_ecom/CHANGELOG.md) and release notes for more information on changes across versions.
