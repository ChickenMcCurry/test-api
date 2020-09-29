<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20200929185734 extends AbstractMigration
{
    public function getDescription() : string
    {
        return '';
    }

    public function up(Schema $schema) : void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE SEQUENCE carte_bancaire_id_seq INCREMENT BY 1 MINVALUE 1 START 1');
        $this->addSql('CREATE SEQUENCE compte_bancaire_id_seq INCREMENT BY 1 MINVALUE 1 START 1');
        $this->addSql('CREATE SEQUENCE utilisateur_id_seq INCREMENT BY 1 MINVALUE 1 START 1');
        $this->addSql('CREATE TABLE carte_bancaire (id INT NOT NULL, compte_bancaire_id INT NOT NULL, numero VARCHAR(16) NOT NULL, id_reference_partenaire INT NOT NULL, status INT NOT NULL, date_expiration DATE NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_59E3C22DAF1E371E ON carte_bancaire (compte_bancaire_id)');
        $this->addSql('CREATE TABLE compte_bancaire (id INT NOT NULL, utilisateur_id INT NOT NULL, iban VARCHAR(30) NOT NULL, bic VARCHAR(11) NOT NULL, id_reference_partenaire INT NOT NULL, balance BIGINT NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_50BC21DEFB88E14F ON compte_bancaire (utilisateur_id)');
        $this->addSql('CREATE TABLE utilisateur (id INT NOT NULL, nom VARCHAR(255) NOT NULL, prenom VARCHAR(255) NOT NULL, date_naissance DATE NOT NULL, email VARCHAR(255) NOT NULL, telephone VARCHAR(10) DEFAULT NULL, PRIMARY KEY(id))');
        $this->addSql('ALTER TABLE carte_bancaire ADD CONSTRAINT FK_59E3C22DAF1E371E FOREIGN KEY (compte_bancaire_id) REFERENCES compte_bancaire (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE compte_bancaire ADD CONSTRAINT FK_50BC21DEFB88E14F FOREIGN KEY (utilisateur_id) REFERENCES utilisateur (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
    }

    public function down(Schema $schema) : void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE SCHEMA public');
        $this->addSql('ALTER TABLE carte_bancaire DROP CONSTRAINT FK_59E3C22DAF1E371E');
        $this->addSql('ALTER TABLE compte_bancaire DROP CONSTRAINT FK_50BC21DEFB88E14F');
        $this->addSql('DROP SEQUENCE carte_bancaire_id_seq CASCADE');
        $this->addSql('DROP SEQUENCE compte_bancaire_id_seq CASCADE');
        $this->addSql('DROP SEQUENCE utilisateur_id_seq CASCADE');
        $this->addSql('DROP TABLE carte_bancaire');
        $this->addSql('DROP TABLE compte_bancaire');
        $this->addSql('DROP TABLE utilisateur');
    }
}
