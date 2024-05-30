# rust-i18n
Simple translation management system written in rust

## Project Scope

## Project Out-Of-Scope
- Authentication needs to be implemented by used service layer. This software does not offer a way of managing user access to specific translations nor does it enforce any.

## Open ToDo's:
- [x] Define Basic Database structure for postgres
Expectations:
- ✅ A user (string, could be an uuid) can create a new translation `project` under which all translations are managed.
- ✅ A project has a default language and a name under which everything operates
- ✅ A project consists of `subgroups`, `subgroups` are similar translation-groups and are used for a more in-depth representation of translations (e.g. `auth.login` is a group that contains multiple translations for the topic of authentication on a login page). Subgroups are stored in a separate table.
- ✅ Subgroups are stored in whole by key (e.g. `auth.login`), are referenced to a project, ~and can be referred to a parent (optional)~. This means that `auth` can have multiple "children". Some of those children are direct translations, some other are groups that can be further nested or otherwise contain translations
- ✅ A subgroup of `auth`, e.g. `auth.login` constricts `login` to be a subgroup. No translation named `login` and being assigned to sub-group `auth` is allowed (covered by procedure).
- ✅ A subgroup can have one or more translations. Translations are stored in a seperated table.
- ✅ A translation is always assigned to a subgroup, has a key to be referred to and an indicator which language it is currently translating, and of course the text that is translated to the language assigned.
- ✅ The sub-group-key, the translation-key and the translation-language, are in whole unique.

- [ ] Implement POC for rust without actual database and axum service layer
Expectations:
- We expect the translations of the backend to return in a simple key-value pair. The key is the whole sub-group + translation-key constellation, the value represents the translation itself.
- A vector of translations should be converted to a json-object representing the traditional translation schema used in modern website i18n-solutions
- Use of serde

- [x] Install diesel for the project, and create first migrations for the POC

- [x] Create Stored Procedures / Functions for inserting new subgroups
Expectations:
- ✅ Procedure checks, if for a given key, a translation is already existent. If true, raise an exception.
- ✅ sub-groups can be any length of dot-delimited (`.`) string. If subgroups do not exist yet, new ones will be generated.

- [ ] Create Stored Procedures / Functions for inserting a translation assigned to a subgroup
Expectations:
- Procedure checks, if for a given key, a sub-group is already existent. If true, raise an exception.
- If no language-key is specified, use default-language key from project.

- [ ] Write Service Layer with Axum
Expectations:
- Create Project
- Update Project settings
- Delete Project
- Create Subgroup
- Delete Subgroup
- Insert Translation
- Delete Translation
- Update Translation
- Add new language to translation (generates empty translations for a project in the new language)
