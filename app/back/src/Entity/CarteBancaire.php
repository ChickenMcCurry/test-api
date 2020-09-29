<?php

namespace App\Entity;

use App\Repository\CarteBancaireRepository;
use Doctrine\ORM\Mapping as ORM;
use ApiPlatform\Core\Annotation\ApiResource;

/**
 * @ORM\Entity(repositoryClass=CarteBancaireRepository::class)
 * @ApiResource
 */
class CarteBancaire
{
    /**
     * @ORM\Id
     * @ORM\GeneratedValue
     * @ORM\Column(type="integer")
     */
    private $id;

    /**
     * @ORM\Column(type="string", length=16)
     */
    private $numero;

    /**
     * @ORM\Column(type="integer")
     */
    private $idReferencePartenaire;

    /**
     * @ORM\Column(type="integer")
     */
    private $status;

    /**
     * @ORM\Column(type="date")
     */
    private $dateExpiration;

    /**
     * @ORM\OneToOne(targetEntity=CompteBancaire::class, inversedBy="carteBancaire", cascade={"persist", "remove"})
     * @ORM\JoinColumn(nullable=false)
     */
    private $compteBancaire;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getNumero(): ?string
    {
        return $this->numero;
    }

    public function setNumero(string $numero): self
    {
        $this->numero = $numero;

        return $this;
    }

    public function getIdReferencePartenaire(): ?int
    {
        return $this->idReferencePartenaire;
    }

    public function setIdReferencePartenaire(int $idReferencePartenaire): self
    {
        $this->idReferencePartenaire = $idReferencePartenaire;

        return $this;
    }

    public function getStatus(): ?int
    {
        return $this->status;
    }

    public function setStatus(int $status): self
    {
        $this->status = $status;

        return $this;
    }

    public function getDateExpiration(): ?\DateTimeInterface
    {
        return $this->dateExpiration;
    }

    public function setDateExpiration(\DateTimeInterface $dateExpiration): self
    {
        $this->dateExpiration = $dateExpiration;

        return $this;
    }

    public function getCompteBancaire(): ?CompteBancaire
    {
        return $this->compteBancaire;
    }

    public function setCompteBancaire(CompteBancaire $compteBancaire): self
    {
        $this->compteBancaire = $compteBancaire;

        return $this;
    }
}
