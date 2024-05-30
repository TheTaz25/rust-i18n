// @generated automatically by Diesel CLI.

diesel::table! {
    tgroup (id) {
        id -> Int4,
        #[max_length = 128]
        name -> Varchar,
        project -> Int4,
    }
}

diesel::table! {
    tproject (id) {
        id -> Int4,
        #[max_length = 64]
        name -> Varchar,
        #[max_length = 64]
        owner -> Varchar,
        #[max_length = 8]
        default_lang -> Varchar,
    }
}

diesel::table! {
    translation (id) {
        id -> Int8,
        group_id -> Int4,
        #[max_length = 16]
        lang -> Varchar,
        #[max_length = 48]
        key -> Varchar,
        translated -> Nullable<Text>,
    }
}

diesel::joinable!(tgroup -> tproject (project));
diesel::joinable!(translation -> tgroup (group_id));

diesel::allow_tables_to_appear_in_same_query!(
    tgroup,
    tproject,
    translation,
);
