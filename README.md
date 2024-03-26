# Overview
- Provides transformation for raw tables extracted from Netsuite via Stitch, to reduce engineer hours arising from exploring and developing models for Netsuite data
- Enable data team to be exposed to the specification of Netsuite data, and transformations need to be implemented to create final marts table for analysis and reporting purposes
- Provide detailed logic for a specific use case, instead of general transformations like the Fivetran [package](https://github.com/fivetran/dbt_netsuite_source)](https://github.com/fivetran/dbt_netsuite_source)
- Generates a comprehensive data dictionary of your source and modeled Netsuite data through the dbt docs site.

# Use case
The package is originally designed for an e-commerce company. The company is a startup with high growth and is present in different countries. They have plenty of subsidiaries and customers from different states of the US and Canada.
Apart from being the main accounting system, Netsuite is used for inventory management. Products or inventories are distributed to customers via nearby subsidiaries. At the end of each financial year (FY), the accounting and finance department needs to consolidate financial reports from different subsidiaries, reported in different currencies to generate the consolidated financial report, including parent and all subsidiaries' financial figures.
One of the role of finance team, is to provide budgets for upcoming FY. Budget can be sliced down to various elements such as items, departments, account or accounting period.

# User manual

## Step 1. Prerequisites
To use this package, you must have At least either one Netsuite connector syncing the respective tables to your destination via Stitch:

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
currently, This package is compatible with Snowflake destination only


## Step 2: Install the package
Include the following package version in your packages.yml file:
> TIP: [Read the dbt docs](https://docs.getdbt.com/docs/build/packages) for more information on installing packages.

```yaml
packages:
  - git: "https://github.com/joon-solutions/dbt_netsuite_ecom.git" # git URL
    revision: main # tag or branch name
```

## Step 3: Define Database credentials
To use the package, you need to declare below variables as environment variables in your local machine or the servers where dbt is deployed:
- DBT_ACCOUNT: Snowflake account hosted on a cloud platform in a geographical region
- DBT_USER: username to use for connecting to Snowflake
- DBT_PASSWORD: password to use for connecting to Snowflake
- DBT_ROLE: role to access into database and schema
- DBT_DB: database to output dbt models to
- DBT_WH: warehouse to process run of dbt models
- DBT_SCHEMA: schema to output dbt models to

> TIP: [Read the dbt docs](https://docs.getdbt.com/docs/core/connect-data-platform/snowflake-setup) for more information on specifying Snowflake's credentials

```yml
vars:
    netsuite_database: your_destination_name
    NESTUITE_SOURCE_SCHEMA: your_schema_name 
```

## Step 4: Define database and schema variables
By default, this package runs using your `raw` database the `netsuite` schema. If this is not where your Netsuite data is (for example, if your netsuite schema is named `netsuite_abc`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
    netsuite_database: your_destination_name
    NESTUITE_SOURCE_SCHEMA: your_schema_name 
```

# 🔍 Does this package have dependencies?
This dbt package is dependent on the following dbt packages. Please be aware that these dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.
    
```yml
packages:
    - package: dbt-labs/dbt_utils
      version: [">=1.1.0", "<2.0.0"]

```
# 🙌 How is this package maintained?
The Joon team maintaining this package _only_ maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://github.com/joon-solutions/dbt_netsuite_ecom) of the package and refer to the [CHANGELOG](https://github.com/joon-solutions/dbt_netsuite_ecom/CHANGELOG.md) and release notes for more information on changes across versions.
